Q = read.csv("Questions.csv"); colnames(Q)[1] = "Group"
Groups = read.csv("Groups.csv"); colnames(Groups)[1] = "Group"
source("LDA.R")

shinyServer(function(input, output){
  # ----REACTIVE INPUTS DEPENDING ON Q0 -----------
  DriverQuestions = Q[Q$Group == "Driver" & Q$Qnum != 0,]
  NonDriverQuestions = Q[Q$Group == "Non-Driver" & Q$Qnum != 0,]
  output$DriverInput = renderUI({
      conditionalPanel(
        condition = "input.Q0 > 4",
        lapply(1:nrow(DriverQuestions),
               function(i){
                 radioButtons(paste0("Q",DriverQuestions$Qnum[i]), label = DriverQuestions$Label[i],
                              choices = list("Strongly Disagree" = 1,
                                             "Disagree" = 2,
                                             "Neutral" = 3,
                                             "Agree" = 4,
                                             "Strongly Agree" = 5),
                              inline = TRUE)
               }
        )
    )
  })
  
  
  output$NonDriverInput = renderUI({
    conditionalPanel(
      condition = "input.Q0 < 5",
      lapply(1:nrow(NonDriverQuestions),
             function(i){
               radioButtons(paste0("Q",NonDriverQuestions$Qnum[i]), label = NonDriverQuestions$Label[i],
                            choices = list("Strongly Disagree" = 1,
                                           "Disagree" = 2,
                                           "Neutral" = 3,
                                           "Agree" = 4,
                                           "Strongly Agree" = 5),
                            inline = TRUE)
             }
      )
    )
  })
  
  # -------- USE LDA TO PREDICT GROUP ---------
  calc = eventReactive(input$GoButton,{
    if (input$Q0 >= 5){
      Responses = numeric(0)
      for (i in 1:nrow(DriverQuestions)){
        Responses = c(Responses, as.numeric(input[[paste0("Q", DriverQuestions$Qnum[i])]]) )
      }
      Pred_Group = LDA("Driver", Responses)
    }
    if (input$Q0 < 5){
      Responses = numeric(0)
      for (i in 1:nrow(NonDriverQuestions)){
        Responses = c(Responses, as.numeric(input[[paste0("Q", NonDriverQuestions$Qnum[i])]]) )
      }
      Pred_Group = LDA("Non-Driver", Responses)
    }
    return(Pred_Group)
  })
  
  # ----- Output Group Name and Description ----------
  output$GroupName = renderUI({
    PredGroup = calc()
    GroupName = Groups$Name[Groups$Group == PredGroup]
    return(HTML(paste("<b>", GroupName, "</b>")))
  })
  output$GroupDesc = renderText({
    PredGroup = calc()
    GroupDesc = as.character(Groups$Desc[Groups$Group == PredGroup])
    return(GroupDesc)
  })
})


