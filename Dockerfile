# Use an official Elixir runtime as a parent image
FROM elixir:latest

# Install debian packages
RUN apt-get update && \
    apt-get install -y postgresql-client && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install --global yarn && \
    apt-get clean

# Install Phoenix packages
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix files and package.json first to leverage Docker cache
WORKDIR /app
COPY mix.exs mix.lock ./
COPY assets/package.json assets/package-lock.json ./assets/

# Install Elixir and Node.js dependencies (cached)
RUN mix deps.get --only prod && \
    cd assets && yarn install --production

# Pre-fetch the Tailwind binary to cache it
RUN MIX_ENV=prod mix tailwind.install

# Copy the rest of the files
COPY . .

RUN mix assets.deploy
RUN mix compile

# Compile the project
RUN MIX_ENV=prod mix compile

# Run Phoenix migrations
CMD ["/app/entrypoint.sh"]
