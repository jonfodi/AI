# Select a base image and specific tag
FROM jupyter/scipy-notebook:2023-07-10

# Run Individual Commands
RUN pip install httpx

# Switch to root to change permissions
USER root
RUN chown -R $NB_UID:$NB_GID /home/jovyan/work
COPY scripts/start-up.sh /home/jovyan/start-up.sh
COPY training_code/ /home/jovyan/work
COPY test/test.txt /
# Copy any files or scripts into the Container
COPY config/jupyter_notebook_config.py /home/jovyan/.jupyter/

# Install the requirements
RUN pip install -r /home/jovyan/work/requirements.txt

RUN chmod +x /home/jovyan/start-up.sh
RUN echo "test"

# Switch back to jovyan user
USER $NB_UID

