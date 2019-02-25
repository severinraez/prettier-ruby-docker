FROM ruby:2.5-stretch

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g $GROUP_ID app && \
    useradd -u $USER_ID -m -g app -d /home/app app && \
    apt-get update && \
    # For node / yarn below
    apt-get install -y apt-transport-https && \
    # Add node and rails repositories
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    curl -sL https://deb.nodesource.com/setup_11.x | bash - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" \
      | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y \
      nodejs yarn && \
    rm -rf /var/lib/apt/lists/*

ADD ./root .

RUN chown -R app:app /opt/prettier

USER app

RUN cd /opt/prettier; yarn add --dev prettier @prettier/plugin-ruby

ENV PATH="/opt/prettier/node_modules/.bin:${PATH}"

WORKDIR /opt/src
