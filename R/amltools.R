## Copyright (c) Microsoft Corporation.  All rights reserved.

connect_to_aml <- function()
{
  print("Enter Azure ML workspace id")
  amlworkspace <<- scan(,what="",quiet=TRUE,nlines=1)
  print("Enter Azure ML authorization token")
  amlauthtoken <<- scan(,what="",quiet=TRUE,nlines=1)
}

packagemodule <- function(functionname) {
  if(!dir.exists(functionname)){
    dir.create(functionname)
  }
  fname = paste(functionname,"\\",functionname,".r",sep="")
  dump(functionname,file=fname)
  xmlpath = "inst\\template.xml"
  xmltemplate <- readChar(xmlpath,file.info(xmlpath)$size)
  xmltemplate <- gsub("AMLFN",functionname,xmltemplate)
  inputname1 = "dataset1"
  xmltemplate <- gsub("AMLINPUT1",inputname1,xmltemplate)
  xmlfname = paste(functionname,"\\",functionname,".xml",sep="")
  fc <- file(xmlfname)
  writeLines(xmltemplate,fc)
  close(fc)
}

deploymodule <- function(functionname) {
  packagemodule(functionname)
  python_args <- paste(amlworkspace,amlauthtoken,functionname)
  print("Uploading and deploying module...")
  python_cmd <- paste("python.exe inst\\upload_register.py",python_args)
  shell(python_cmd)
  print("Deployment complete, refresh (F5) your modules in AML Studio.")
}



