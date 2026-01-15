# Dockerfile para Jenkins con todas las herramientas necesarias
FROM jenkins/jenkins:lts-jdk21

USER root

# Instalar dependencias del sistema
RUN apt-get update && \
    apt-get install -y \
        curl \
        wget \
        gnupg \
        lsb-release \
        ca-certificates \
        build-essential \
        git \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Instalar Node.js 22.x
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Instalar Python (usar la versión disponible en Trixie)
RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-venv \
        python3-dev \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Verificar versión de Python instalada
RUN python3 --version

# Instalar Docker CLI (compatible con el daemon del host)
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Copiar lista de plugins
COPY jenkins-config/plugins.txt /usr/share/jenkins/ref/plugins.txt

# Instalar plugins desde archivo
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Configurar permisos
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref

# Verificar instalaciones
RUN java --version && \
    node --version && \
    npm --version && \
    python3 --version && \
    pip3 --version && \
    git --version && \
    docker --version && \
    docker compose version && \
    psql --version || echo "Algunas verificaciones fallaron"

# Volver al usuario jenkins
USER jenkins

# Exponer puertos
EXPOSE 8080 50000