# AzureMLRModuleBuilder

An RStudio add-in for deploying R functions as Azure ML modules. To use, open as project in RStudio.

## Requirements:
* R 3.2.4
* RStudio 0.99.893
* Shiny R package >=0.13
* miniUI R package >=0.1.1
* rstudioapi R package >=0.5
* Python 2.7.3
* Requests Python module 2.7.0

##Known limitations:
* Only 1-input-1-output function are supported. Module parameters are not supported.
* Deployed function should not depend on other user functions (no dependency walk implemented)
* Deployment of packages is not supported.
  
RStudio and Shiny are trademarks of RStudio, Inc.
