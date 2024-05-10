Instructions for deployment:
-log in the EC2 instance 
-run the commands 'aws sso login --sso-session nu-sso' and 'sudo chmod 666 /var/run/docker.sock'
- run the command: docker start etl-container
- run the command: docker exec -it etl-container /bin/bash
- start the jupyter notebook by running the command: jupyter notebook --ip=0.0.0.0
- Upload the original_heart_database.db to the path
- go to HW2/src/.ipynb-checkpoints/HW2modelprediction.ipynb
- run every cell in order
