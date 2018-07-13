LDA = function(Group, resp){
  Q = read.csv("Questions.csv"); colnames(Q)[1] = "Group"
  
  if (Group == "Non-Driver"){
    coef = Q[c("C1", "C2", "C3")][Q$Group == "Non-Driver",]
    coef = as.matrix(coef)
    X = matrix(c(1, resp), ncol = 1)
    print(dim(X)); print(dim(coef))
    DisFunc = t(X)%*%coef
    Group = (1:3)[which.max(DisFunc)]
  }
  if (Group == "Driver"){
    coef = Q[c("C1", "C2", "C3", "C4")][Q$Group == "Driver",]
    coef = as.matrix(coef)
    X = matrix(c(1, resp), ncol = 1)
    DisFunc = t(X)%*%coef
    Group = (4:7)[which.max(DisFunc)]
  }
  return(Group)
}