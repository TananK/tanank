## Machine Learning Pipeline Monitoring

In this use case, the machine learning pipeline feeds in 200+ GB and scores 100 million data point per day. The system uses Tableau as a main data visualization tool, Metric Insight as an anomaly detection system, and Figure8 as a human-in-the-loop platform, and AWS as a foundation for the pipeline. The objective is to analyze performance of the models through real-time dashboards when the anomaly detection system finds a trend that could threaten the pipeline in order to provide data-driven recommendations to the data science team to refit or stop the pipeline.

The monitoring system is broken down into three parts; pre-score monitoring, post-score monitoring, and human-in-the-loop validation.

### Pre-score monitoring
Before data goes into the machine learning model, it is important to know if characteristic of the data is consistent with the historical trend. Although the data is expected to gradually drift overtime, a sudden movement in the data can signify an error in the software or data processing. In this ML pipeline, each data point represents a place and the features are called attribute. The pipeline collects historical information of every place that goes through the model, hence, it knows if the place is new, updated, or the same. It also knows the attributes and values that have been updated, in which the information is used for investigation. Below is a list of metrics used to monitor pre-score data.

1. The number of new data point compared to the previous run
2. The number of updated data point compared to the previous run
3. The number of updated data point compared to the previous run dimensioned by attribute
4. The number of updated data point compared to the previous run dimensioned by attribute and country

As shown in the pre-score monitoring dashboard below, the first and second metrics are used for high-level monitoring of the pipeline and the third and forth metrics produce in-depth insight into the data. Alert algorithm is set on the first metric where the number of new data point received impacts KPI of the project and the third metric only on the attributes they provide strong signal for the prediction. The alert will be sent when the number of data point of the monitored elements increases or decreases more than 10% from the previous run. From the experience, some of the reasons for unusual patterns in the data are:

- Bugs in the pipeline after a new patch is updated
- Routine maintenance at the data source
- Software updates in the infrastructure or operation system

It is neccesary to prevent corrupted data to feed into the ML model as it takes more time to revert the process than stop the pipeline. The change in data usage itself is subtle and won't trigger the alert. The gradual change in the trend can be detected and analyzed better with the post-score monitoring as described in the next topic.


### Post-score monitoring
Output of the ML prediction is called "score" and it is a probability between 0 to 1. For an ease of visualization, each score is divided into 20 bins, eg. bin 1 equals to score 0 to 0.05 and bin 20 equals to score 0.95 to 1. Then the process counts the number of data point that fall into each bin, thus, creating a histogram of the score from each run. In order to compare the score distribution from each run, the number of data point from each bin is normalized using a proportion from the total number from that run. After the monitoring system is in place, alert rule is set on the mean of the score of each model to notify the team when it increases or decreases more than 10% compared to the previous run. The result can be seen in the post-score monitoring dashboard below.

Although most significant issues in the data can be detected from the pre-score data as they say "garbage in, garbage out", there are many reasons why it is important to monitor the score distribution from the ML model as well. Below is a list of use case from score distribution monitoring.

- To analyze the overall performance of each version of ML model when they are deployed
- To identify trends in the prediction and the factors that cause them in order to improve feature engineering method and decide a point to refit the model 
- To determine the cutoff value (the score that is accepted as positive) and evaluate the quantitative impact to the bottom line of the project

With the pre and post score monitoring, the team can see the quantitative movement of the input data and score distribution in real-time. However, it doesn't represent the quality of the predictions. Therefore, human-in-the-loop validation is needed to verify the accuracy of the ML model in production pipeline.


### Human-in-the-loop validation 
Human-in-the-loop validation is used to calculate the confusion matrix (also known as error matrix). Human judgements are compared to the machine judgements in order to find numbers of true positive, true negative, false positive, and false negative from each run. The numbers are then used to calculate precision and recall using the method as shown in the figure below.

<img src="https://upload.wikimedia.org/wikipedia/commons/2/26/Precisionrecall.svg" width="200" height="400" alt="Walber CC BY-SA 4.0" align="middle"/> 

Precision is used as a main indicator to the performance of this ML model because correct prediction is more important than missing the actual ones. If precision of a model drops below 80% for 3 weeks in a row, it is considered a major drifted and a full investigation including the possibility of refitting model will occur. You can find the flowchart of the human-in-the-loop validation process below.

#### Human-in-the-loop validation Flowchart 

<img src="https://raw.githubusercontent.com/TananK/tanank/ML_Pipeline_Monitoring/Model%20Auditing.png" alt="Machine Learning Pipeline Monitoring Flowchart"/>
