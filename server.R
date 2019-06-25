### Load required packages
library(shiny)
library(tidyverse)
library(Rmisc)

### Load required data
rpmmm <- readRDS('data/RPMMM_all.rds')
si <- read_csv('data/sample_info.csv')


shinyServer(function(input, output) {
  
  df_out <- reactive({
    df_out <- rpmmm %>%
      filter(miR %in% input$moi)
    
    print(df_out)
    
    return(df_out)
  })
  

  
  
  output$expressionPlot <- renderPlot({
    
    print(si)

    filtered <- df_out() %>%
      gather(Sample, RPMMM, -miR) %>%
      inner_join(si) %>%
      summarySE(., measurevar = 'RPMMM', c('Experiment', 'Treatment', 'miR')) %>%
      mutate(Treatment = factor(Treatment, levels = c('Control', 'Treatment')),
             Experiment = factor(Experiment, levels = c('OBOB', 'STZ', 'ZF', 'UCD', 'LIRKO')),
             upper = RPMMM + se,
             lower = RPMMM - se)
    
    print(filtered)
    
    p <- ggplot(filtered, aes_string(x='Experiment', y='RPMMM', fill = 'Treatment')) + 
      geom_bar(stat = "identity", position=position_dodge(.9), color = 'black') + 
      geom_errorbar(aes(ymin=(upper), ymax=(lower)),size=.5, width=.2, stat = "identity", position=position_dodge(0.9)) +
      facet_wrap(~miR, scales = 'free') +
      scale_fill_manual('',
                        labels = c('Matched Control', 'Disease Model'),
                        values = c('orange', 'skyblue')) +
      scale_x_discrete(labels = c('OB', 'STZ', 'ZF', 'UCD', 'LIRKO')) +
      scale_y_continuous(limits = c(0, max(filtered$upper) * 1.1)) +
      theme_classic() +
      theme(panel.grid = element_blank(),
            text = element_text(color = 'black', size = 22),
            axis.text = element_text(color = 'black'),
            strip.background = element_blank(),
            axis.title = element_text(color = 'black', size = 22),
            axis.title.x = element_blank(),
            legend.key.height = unit(5, 'line'))
    print(p)
    
  }, height=700)
 
  
  output$downloadData <- downloadHandler(
    filename <- 'miR_data.zip',
    
    content <- function(file) {
      file.copy('data/data.zip', file)
    })
  
}
)