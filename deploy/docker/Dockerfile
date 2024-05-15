# Select a base image and specific tag
FROM jupyter/scipy-notebook:2023-07-10

# Run Individual Commands
RUN pip install httpx

# Clone the GitHub repository and install the requirements
RUN git clone https://github.com/wcarrollrai/containers-demo /home/jovyan/work \
    && pip install -r /home/jovyan/work/requirements.txt

# Copy any files or scripts into the Container
COPY jupyter_notebook_config.py /home/jovyan/.jupyter/

# Switch to root to change permissions
USER root
RUN chown -R $NB_UID:$NB_GID /home/jovyan/work
COPY start-up.sh /home/jovyan/start-up.sh
RUN chmod +x /home/jovyan/start-up.sh
RUN echo "test"

# Switch back to jovyan user
USER $NB_UID
