library(shiny)
library(ggplot2)

rpmmm <- readRDS('data/RPMMM_all.rds')

fluidPage(
  
  titlePanel("Animal models of metabolic dysfunction with hepatic insulin resistance"),
  
  fluidRow(
    column(10, offset = 1,
           h4('Small RNA-seq-based microRNA data')
    )
  ),
  
  hr(),
  
  sidebarPanel(

    selectInput('moi', 
                'Pick your miRNA(s) of interest:', 
                unique(rpmmm$miR), 
                multiple = T,
                selected = 'miR-29b-1-3p'),
    
    h5('Abbreviations of models:'),
    
    p("STZ = Streptozotocin (STZ) treated"),
    p("OB = Leptin-deficient (ob/ob)"),
    p("ZF = Zucker fatty"),
    p("UCD = UC Davis type 2 diabetes"),
    p("LIRKO = Liver-specific insulin receptor knockout"),
    hr(),
    
    downloadButton("downloadData", "Download sample info and counts")
  ),
  
  mainPanel(  
    plotOutput('expressionPlot')
  ),
  
  hr()
  
)
