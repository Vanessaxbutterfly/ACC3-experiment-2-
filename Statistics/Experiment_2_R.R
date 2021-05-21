#This file explores additional statistics not explored in SPSS

#load the dataset
ACC3_Analysis_edited <- read.csv2("~/Semester 6/Bachelor Thesis/acc3/acc3/Statistics/ACC3_Analysis_edited.csv")
View(ACC3_Analysis_edited)

#check the homogenitiy of vaiance assumption
library(car)
leveneTest(response ~ Condition,data = ACC3_Analysis_edited)
leveneTest(response ~ Condition*CarrierType,data = ACC3_Analysis_edited)


#convert animacy of pictures and text to numeric vector
ACC3_Analysis_edited$a.p <- unclass(ACC3_Analysis_edited$animacy.picture)
ACC3_Analysis_edited$a.t <- unclass(ACC3_Analysis_edited$animacy.text)

#perform a Chi-square test
chisq.test(table(ACC3_Analysis_edited$response,ACC3_Analysis_edited$Condition))#significant

#try this for animacy of the picture and text seperately
chisq.test(table(ACC3_Analysis_edited$response,ACC3_Analysis_edited$a.p))#not significant
chisq.test(table(ACC3_Analysis_edited$response,ACC3_Analysis_edited$a.t))#significant

#interaction of them is significant
chisq.test(table(ACC3_Analysis_edited$response,ACC3_Analysis_edited$a.p*ACC3_Analysis_edited$a.t))

chisq.test(table(ACC3_Analysis_edited$response,ACC3_Analysis_edited$CarrierType))#not signficiant


#wilcoxon rank sum test between reaction time and responses (more sense = lower RT)
ACC3_Analysis_edited$logRT <- log(ACC3_Analysis_edited$RT)
wilcox.test(ACC3_Analysis_edited$logRT~ACC3_Analysis_edited$response)

#subset and calculate median to report
zero <- subset(ACC3_Analysis_edited, response == 0)
one <- subset(ACC3_Analysis_edited, response == 1)

#calculate mean and median 
mean(one$RT)
sd(zero$RT)
mean(one$RT)
sd(zero$RT)

median(one$RT) 
median(zero$RT)

median(one$response) 
median(zero$response)

