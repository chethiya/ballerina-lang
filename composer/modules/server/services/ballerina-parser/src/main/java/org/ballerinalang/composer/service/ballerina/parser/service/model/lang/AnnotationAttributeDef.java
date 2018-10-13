/*
 * Copyright (c) 2017, WSO2 Inc. (http://wso2.com) All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
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

package org.ballerinalang.composer.service.ballerina.parser.service.model.lang;


/**
 * Annotation attribute value.
 */
public class AnnotationAttributeDef {
    private String bType = null;

    private boolean arrayType;

    private String packagePath = null;

    private String identifier = null;

    private String fileName = null;

    public String getbType() {
        return bType;
    }
    
    public void setBType(String bType) {
        this.bType = bType;
    }
    
    public void setArrayType(boolean arrayType) {
        this.arrayType = arrayType;
    }
    
    public boolean isArrayType() {
        return arrayType;
    }
    
    public String getPackagePath() {
        return packagePath;
    }
    
    public void setPackagePath(String packagePath) {
        this.packagePath = packagePath;
    }
    
    public String getIdentifier() {
        return identifier;
    }
    
    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return "AnnotationAttributeDef{" + "bType='" + bType + '\'' + ", packagePath='" + packagePath + '\'' + ", " +
               "identifier='" + identifier + '\'' + '}';
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
}