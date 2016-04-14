connect_to_aml_gui <- function(){
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Connect to Azure ML Workspace"),
    miniUI::miniContentPanel(
      shiny::textInput(inputId = "wp","Workspace ID",""),
      shiny::textInput(inputId = "at","Authorization Token","")
    )
  )

  server <- function(input,output,session){
    shiny::observeEvent(input$done,{
    amlworkspace <<- input$wp
    amlauthtoken <<- input$at
    shiny::stopApp()
    })
    shiny::observeEvent(input$cancel,{
      shiny::stopApp()
    })
  }
  shiny::runGadget(ui,server)
}

deploymodule_gui_driver <- function(){
  if(!exists("amlworkspace") || !exists("amlauthtoken")){
    connect_to_aml_gui()
  }
  functionname = getfunctionname_gui()
  if(!is.null(functionname))
  {
    #TBD: getfunctionparams_gui(functionname)
    deploymodule(functionname)
  }
}

getfunctionname_gui <- function(){
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Deploy Module to Azure ML"),
    miniUI::miniContentPanel(
      shiny::textInput(inputId = "functionname","R Function Name","")
    )
  )

  server <- function(input,output,session){
    shiny::observeEvent(input$done,{
      shiny::stopApp(returnValue = input$functionname)
    })
    shiny::observeEvent(input$cancel,{
      shiny::stopApp(returnValue = NULL)
    })
  }
  shiny::runGadget(ui,server)
}

getfunctionparams_gui <- function(functionname){
  funargs <- names(formals(functionname))
  selecttype <- function(elem){shiny::selectInput(inputId = elem,elem,c("data.frame input port","string","float","int"))}
  dropdowns <- lapply(funargs,selecttype)
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Specify input parameters"),
    miniUI::miniContentPanel(dropdowns)
  )

  server <- function(input,output,session){
    shiny::observeEvent(input$done,{
      shiny::stopApp()
    })
    shiny::observeEvent(input$cancel,{
      shiny::stopApp(returnvalue = NULL)
    })
  }
  shiny::runGadget(ui,server)
}


