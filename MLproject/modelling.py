import mlflow
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
import numpy as np
import sys
import os
import warnings

if __name__ == "__main__": 
    warnings.filterwarnings("ignore")
    np.random.seed(42)

    n_estimators = int(sys.argv[1]) if len(sys.argv) > 1 else 200
    max_depth = int(sys.argv[2]) if len(sys.argv) > 2 else 20   
    min_sample_split = 5
    min_sample_leaf = 3
    random_state = 42
    criterion = 'gini'

    # file dataset
    base_path = os.path.dirname(os.path.abspath(__file__))
    X_train = pd.read_csv(os.path.join(base_path, "X_train.csv"))
    X_test = pd.read_csv(os.path.join(base_path, "X_test.csv"))
    y_train = pd.read_csv(os.path.join(base_path, "y_train.csv"))
    y_test = pd.read_csv(os.path.join(base_path, "y_test.csv"))

    

    input_example = X_train[0:5]

    with mlflow.start_run():
        
        model = RandomForestClassifier(
            n_estimators=n_estimators,
            max_depth=max_depth,
            min_samples_leaf=min_sample_leaf,
            min_samples_split=min_sample_split, 
            random_state=random_state,
            criterion=criterion
        )

        mlflow.log_param('n_estimators', n_estimators)
        mlflow.log_param('max_depth', max_depth)
        mlflow.log_param('min_sample_split', min_sample_split)
        mlflow.log_param('min_sample_leaf', min_sample_leaf)
        mlflow.log_param('random_state', random_state)
        mlflow.log_param('criterion', criterion)

        model.fit(X_train, y_train)
        y_pred = model.predict(X_test)

                               
        mlflow.sklearn.log_model(
            sk_model=model,
            artifact_path="model",
            input_example=input_example
        
                            
        # evaluasi
        mlflow.log_metric("accuracy", accuracy_score(y_test, y_pred))
        mlflow.log_metric("precision", precision_score(y_test, y_pred, average="weighted"))
        mlflow.log_metric("recall", recall_score(y_test, y_pred, average="weighted"))
        mlflow.log_metric("f1_score", f1_score(y_test, y_pred, average="weighted"))
        
