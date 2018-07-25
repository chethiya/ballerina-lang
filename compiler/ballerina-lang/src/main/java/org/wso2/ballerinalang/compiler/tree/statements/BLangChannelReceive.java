/*
 * Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License, 
 * Version 2.0 (the "License"); you may not use this file except 
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.wso2.ballerinalang.compiler.tree.statements;

import org.ballerinalang.model.tree.IdentifierNode;
import org.ballerinalang.model.tree.NodeKind;
import org.ballerinalang.model.tree.statements.ChannelReceiveNode;
import org.wso2.ballerinalang.compiler.tree.BLangNodeVisitor;
import org.wso2.ballerinalang.compiler.tree.expressions.BLangExpression;
import org.wso2.ballerinalang.compiler.tree.expressions.BLangVariableReference;

/**
 * Implementation of channel receive statement.
 * @since 0.981
 */
public class BLangChannelReceive extends BLangStatement implements ChannelReceiveNode {
    public BLangVariableReference receiverExpr;
    public BLangExpression keyExpr;
    public IdentifierNode channelIdentifier;

    @Override
    public NodeKind getKind() {
        return NodeKind.CHANNEL_RECEIVE;
    }

    @Override
    public void accept(BLangNodeVisitor visitor) {
        visitor.visit(this);
    }

    public BLangVariableReference getReceiverExpr() {
        return receiverExpr;
    }

    public void setReceiverExpr(BLangVariableReference receiverExpr) {
        this.receiverExpr = receiverExpr;
    }

    public BLangExpression getKey() {
        return keyExpr;
    }

    public void setKey(BLangExpression keyExpr) {
        this.keyExpr = keyExpr;
    }

    public IdentifierNode getChannelName() {
        return channelIdentifier;
    }

    public void setChannelName(IdentifierNode channelIdentifier) {
        this.channelIdentifier = channelIdentifier;
    }
}
