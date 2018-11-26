// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/io;
import ballerina/sql;
import ballerina/h2;
import ballerina/system;

listener http:Listener participant2EP02 = new(8890);

h2:Client testDB = new({
    path: "../../../target/tempdb/",
    name: "TEST_SQL_CONNECTOR",
    username: "SA",
    password: "",
    poolOptions: { maximumPoolSize: 10 },
    dbOptions: { "IFEXISTS": true }
});

State2 state2 = new;

@http:ServiceConfig {
    basePath:"/"
}
service participant2 on participant2EP02 {

    resource function getState(http:Caller ep, http:Request req) {
        http:Response res = new;
        res.setTextPayload(state2.toString());
        state2.reset();
        _ = ep -> respond(res);
    }

    resource function task1 (http:Caller conn, http:Request req) {
        http:Response res = new;
        res.setTextPayload("Resource is invoked");
        var forwardRes = conn -> respond(res);  
        match forwardRes {
            error err => {
                io:print("Participant2 could not send response to participant1. Error:");
                io:println(err.reason());
            }
            () => io:print("");
        }
    }
    @transactions:Participant {
    }
    resource function task2 (http:Caller conn, http:Request req) {
        http:Response res = new;
        string result = "incorrect id";
        if (req.getHeader("x-b7a-xid") == req.getHeader("participant-id")) {
            result = "equal id";
        }
        res.setTextPayload(result);
        var forwardRes = conn -> respond(res);  
        match forwardRes {
            error err => {
                io:print("Participant2 could not send response to participant1. Error:");
                io:println(err.reason());
            }
            () => io:print("");
        }
    }

    resource function testSaveToDatabaseSuccessfulInParticipant(http:Caller ep, http:Request req) {
        saveToDatabase(ep, req, false);
    }

    resource function testSaveToDatabaseFailedInParticipant(http:Caller ep, http:Request req) {
        saveToDatabase(ep, req, true);
    }

    @http:ResourceConfig {
        path: "/checkCustomerExists/{uuid}"
    }
    resource function checkCustomerExists(http:Caller ep, http:Request req, string uuid) {
        http:Response res = new;  res.statusCode = 200;
        sql:Parameter para1 = {sqlType:sql:TYPE_VARCHAR, value:uuid};
        var x = testDB -> select("SELECT registrationID FROM Customers WHERE registrationID = ?", Registration, para1);
        match x {
            table dt => {
               string payload = "";
               while (dt.hasNext()) {
                   var reg = <Registration>dt.getNext();
                    if (reg is error) {
                        panic(reg);
                    } else if (reg is Registration) {
                        io:println(reg);
                        payload = reg.REGISTRATIONID;
                    }
               }
               res.setTextPayload(untaint payload);
            }
            error err1 => {
               res.statusCode = 500;
            }
        }

        _ = ep -> respond(res);
    }
}

type Registration record {
    string REGISTRATIONID;
};


@transactions:Participant {
    oncommit:onCommit2,
    onabort:onAbort2
}
function saveToDatabase(http:Caller conn, http:Request req, boolean shouldAbort) {
    http:Caller ep = conn;
    http:Response res = new;  res.statusCode = 200;

    saveToDatabase_localParticipant();
    string uuid = system:uuid();
    var helperRes = trap saveToDatabaseUpdateHelper1(uuid);
    if (helperRes is error) {
        io:println("FAILED!!!");
    }

    res.setTextPayload(uuid);
    var forwardRes = ep -> respond(res);
    match forwardRes {
        error err => {
            io:print("Participant2 could not send response to participant1. Error:");
            io:println(err.reason());
        }
        () => io:print("");
    }
    if(shouldAbort) {
        log:printInfo("can not abort from a participant function");
    }

}

function saveToDatabaseUpdateHelper1(string uuid) {
    var result = testDB->update("Insert into Customers (firstName,lastName,registrationID,creditLimit,country)
                                                     values ('John', 'Doe', '" + uuid + "', 5000.75, 'USA')");
    match result {
        int insertCount => io:println(insertCount);
        error => io:println("");
    }
}

function onAbort2(string transactionid) {
    state2.abortedFunctionCalled = true;
}

function onCommit2(string transactionid) {
    state2.committedFunctionCalled = true;
}

function onLocalParticipantAbort2(string transactionid) {
    state2.localParticipantAbortedFunctionCalled = true;
}

function onLocalParticipantCommit2(string transactionid) {
    state2.localParticipantCommittedFunctionCalled = true;
}

@transactions:Participant {
    oncommit:onLocalParticipantCommit2,
    onabort:onLocalParticipantAbort2
}
function saveToDatabase_localParticipant() {
    log:printInfo("saveToDatabase_localParticipant");
}        

type State2 object {

    boolean abortedFunctionCalled= false;
    boolean committedFunctionCalled= false;
    boolean localParticipantCommittedFunctionCalled= false;
    boolean localParticipantAbortedFunctionCalled= false;


    function reset() {
        self.abortedFunctionCalled = false;
        self.committedFunctionCalled = false;
        self.localParticipantCommittedFunctionCalled = false;
        self.localParticipantAbortedFunctionCalled = false;
    }

    function toString() returns string {
        return io:sprintf("abortedFunctionCalled=%b,committedFunctionCalled=%s," +
                            "localParticipantCommittedFunctionCalled=%s,localParticipantAbortedFunctionCalled=%s",
                            self.abortedFunctionCalled, self.committedFunctionCalled,
                            self.localParticipantCommittedFunctionCalled, self.localParticipantAbortedFunctionCalled);
    }
};
