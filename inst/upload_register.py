## Copyright (c) Microsoft Corporation.  All rights reserved.

import requests
import sys
import os
import zipfile
import warnings

##Create Module Zip
def zipmodule(modulefolder):
    modulezip = modulefolder+'.zip'
    try:
        os.remove(modulezip)
    except OSError:
        pass
    with zipfile.ZipFile(modulezip,'w') as mz:
        for modulefile in os.listdir(modulefolder):
            mz.write(modulefolder+"\\"+modulefile,modulefile)
        mz.close()
    return modulezip

##Upload to AML
def uploadmodule(workspace,authtoken,modulezip):
    f = open(modulezip,'rb')
    data = f.read()
    f.close()
    os.remove(modulezip)
    baseurl = "https://studioapi.azureml.net/"
    uploadapiurl = "api/resourceuploads/workspaces/"
    wpdataseturl = baseurl+uploadapiurl+workspace+"/?userStorage=true&dataTypeId=Zip"
    headers ={}
    headers['Authorization'] = 'Bearer '+authtoken
    headers['x-ms-metaanalytics-authorizationtoken'] = authtoken    
    with warnings.catch_warnings():
        warnings.simplefilter('ignore')
        resp = requests.post(wpdataseturl,headers=headers,data=data)
        headers['content-type'] = 'application/json'
        regurl = baseurl + "api/workspaces/"+workspace+"/modules/custom"
        data2 = resp.content[0:-1]+",\"ClientPoll\":true}"
        resp2 = requests.post(regurl,headers=headers,data=data2)

if __name__ == "__main__":
    workspace = sys.argv[1]
    authtoken = sys.argv[2]
    modulefolder = sys.argv[3]
    modulezip = zipmodule(modulefolder)
    uploadmodule(workspace,authtoken,modulezip)
    
