"use strict";

const AWS = require("aws-sdk");
let dynamo = new AWS.DynamoDB.DocumentClient();

require("aws-sdk/clients/apigatewaymanagementapi");

const CONNECTION_TABLE = "idTable";

const successfullResponse = {
  statusCode: 200,
  body: "everything is alright",
};

module.exports.connectionHandler = (event, context, callback) => {
  console.log(event);

  if (event.requestContext.eventType === "CONNECT") {
    addConnection(event.requestContext.connectionId)
      .then(() => {
        callback(null, successfullResponse);
      })
      .catch((err) => {
        console.log(err);
        callback(null, JSON.stringify(err));
      });
  } else if (event.requestContext.eventType === "DISCONNECT") {
    deleteConnection(event.requestContext.connectionId)
      .then(() => {
        callback(null, successfullResponse);
      })
      .catch((err) => {
        console.log(err);
        callback(null, {
          statusCode: 500,
          body: "Connection failed: " + JSON.stringify(err),
        });
      });
  }
};

module.exports.defaultHandler = (event, context, callback) => {
  console.log("Calling defaultHandler");
  console.log(event);

  callback(null, {
    statusCode: 200,
    body: "defaultHandler",
  });
};

module.exports.sendMessageHandler = (event, context, callback) => {
  sendMessageToAllConnected(event)
    .then(() => {
      callback(null, successfullResponse);
    })
    .catch((err) => {
      callback(null, JSON.stringify(err));
    });
};

const sendMessageToAllConnected = (event) => {
  return getConnectionIds().then((connectionData) => {
    return connectionData.Items.map((connectionId) => {
      return send(event, connectionId.connectionId);
    });
  });
};

const getConnectionIds = () => {
  const params = {
    TableName: CONNECTION_TABLE,
    ProjectionExpression: "connectionId",
  };

  return dynamo.scan(params).promise();
};

const send = (event, connectionId) => {
  const body = JSON.parse(event.body);
  const direction = body.direction;
  const robotID = body.robotID;

  const endpoint =
    event.requestContext.domainName + "/" + event.requestContext.stage;
  const apigwManagementApi = new AWS.ApiGatewayManagementApi({
    apiVersion: "2018-11-29",
    endpoint: endpoint,
  });

  const params = {
    ConnectionId: connectionId,
    Data: JSON.stringify({
      direction: direction,
      robotID: robotID
    }),
  };
  return apigwManagementApi.postToConnection(params).promise();
};

const addConnection = (connectionId) => {
  const params = {
    TableName: CONNECTION_TABLE,
    Item: {
      connectionId: connectionId,
    },
  };

  return dynamo.put(params).promise();
};

const deleteConnection = (connectionId) => {
  const params = {
    TableName: CONNECTION_TABLE,
    Key: {
      connectionId: connectionId,
    },
  };

  return dynamo.delete(params).promise();
};