
import * as React from "react";
import { DiagramConfig } from "../../config/default";
import { DiagramUtils } from "../../diagram/diagram-utils";
import { StmntViewState } from "../../view-model/index";
import { ArrowHead } from "./arrow-head";

const config: DiagramConfig = DiagramUtils.getConfig();

export const ActionInvocation: React.StatelessComponent<{
    model: StmntViewState, action: string
}> = ({
    model, action
}) => {
        const sendLine = { x1: 0, y1: 0, x2: 0, y2: 0 };
        const receiveLine = { x1: 0, y1: 0, x2: 0, y2: 0 };
        const actionProps = { x: 0, y: 0 };

        sendLine.x1 = model.bBox.x;
        sendLine.y1 = sendLine.y2 = model.bBox.y + config.statement.height;
        sendLine.x2 = model.endpoint.bBox.x + (model.endpoint.bBox.w / 2) - 3;

        receiveLine.x1 = sendLine.x1;
        receiveLine.x2 = sendLine.x2;
        receiveLine.y1 = receiveLine.y2 = sendLine.y1 + (config.statement.height / 2);

        actionProps.x = model.bBox.x + config.statement.padding.left;
        actionProps.y = model.bBox.y + (config.statement.height / 2);
        return (
            <g className="action-invocation">
                <line {...sendLine} />
                <ArrowHead direction="right" x={sendLine.x2} y={sendLine.y2} />
                <line {...receiveLine} strokeDasharray={5} />
                <ArrowHead direction="left" x={receiveLine.x1} y={receiveLine.y1} />
                <rect x={sendLine.x2} y={sendLine.y2} width="6" height={(config.statement.height / 2)}
                    className="endpoint-activity" />
                <text {...actionProps}>{action}</text>
            </g>
        );
    };
