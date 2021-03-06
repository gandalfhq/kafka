[![Docker Pulls](https://img.shields.io/docker/pulls/wurstmeister/kafka.svg)](https://hub.docker.com/r/wurstmeister/kafka/)
[![Docker Stars](https://img.shields.io/docker/stars/wurstmeister/kafka.svg)](https://hub.docker.com/r/wurstmeister/kafka/)
[![](https://badge.imagelayers.io/wurstmeister/kafka:latest.svg)](https://imagelayers.io/?images=wurstmeister/kafka:latest)

kafka-docker
============

Dockerfile for [Apache Kafka](http://kafka.apache.org/)

The image is available directly from https://registry.hub.docker.com/

##Pre-Requisites

- install docker-compose [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

##Usage

Start a cluster:

- ```docker-compose up -d ```

Add more brokers:

- ```docker-compose scale kafka=3```

Destroy a cluster:

- ```docker-compose stop```

## Commands

You can enter a command line through docker-compose:

        docker-compose run bash

You can then run commands, with these variables:

- `$KAFKA_HOME` is the Kafka installation directory.
- `zookeeper:2181` is the address for accessing zookeeper
- `kafka:9092` is the address for accessing kafka

For example, you can create some topics:

        $KAFKA_HOME/bin/kafka-topics.sh --create --topic test --partitions 4 --zookeeper zookeeper:2181 --replication-factor 1
        $KAFKA_HOME/bin/kafka-topics.sh --list --zookeeper zookeeper:2181

Or send some messages:

        $KAFKA_HOME/bin/kafka-console-producer.sh --broker-list kafka:9092 --topic test

And read those messages:

        $KAFKA_HOME/bin/kafka-console-consumer.sh --zookeeper zookeeper:2181 --topic test --from-beginning

## Kafka Manager
[Kafka Manager](https://github.com/yahoo/kafka-manager) is included with this compose script. It can be accessed at [http://localhost:9000].

You might have to manually tell the manager about your cluster. To do so, just use a zookeeper address of `zookeeper:2181`.

##Note

The default ```docker-compose.yml``` should be seen as a starting point. By default each broker will get a new port number and broker id on restart. Depending on your use case this might not be desirable. If you need to use specific ports and broker ids, modify the docker-compose configuration accordingly, e.g. [docker-compose-single-broker.yml](https://github.com/wurstmeister/kafka-docker/blob/master/docker-compose-single-broker.yml):

- ```docker-compose -f docker-compose-single-broker.yml up```

##Broker IDs

If you don't specify a broker id in your docker-compose file, it will automatically be generated (see [https://issues.apache.org/jira/browse/KAFKA-1070](https://issues.apache.org/jira/browse/KAFKA-1070). This allows scaling up and down. In this case it is recommended to use the ```--no-recreate``` option of docker-compose to ensure that containers are not re-created and thus keep their names and ids.

## Customization
- modify the ```KAFKA_ADVERTISED_HOST_NAME``` in ```docker-compose.yml``` to match your docker host IP (Note: Do not use localhost or 127.0.0.1 as the host ip if you want to run multiple brokers.)
- if you want to customise any Kafka parameters, simply add them as environment variables in ```docker-compose.yml```, e.g. in order to increase the ```message.max.bytes``` parameter set the environment to ```KAFKA_MESSAGE_MAX_BYTES: 2000000```. To turn off automatic topic creation set ```KAFKA_AUTO_CREATE_TOPICS_ENABLE: 'false'```


##Automatically create topics

If you want to have kafka-docker automatically create topics in Kafka during
creation, a ```KAFKA_CREATE_TOPICS``` environment variable can be
added in ```docker-compose.yml```.

Here is an example snippet from ```docker-compose.yml```:

        environment:
          KAFKA_CREATE_TOPICS: "Topic1:1:3,Topic2:1:1"

```Topic 1``` will have 1 partition and 3 replicas, ```Topic 2``` will have 1 partition and 1 replica.

##Advertised hostname 

You can configure the advertised hostname in different ways 

1. explicitly, using ```KAFKA_ADVERTISED_HOST_NAME``` 
2. via a command, using ```HOSTNAME_COMMAND```, e.g. ```HOSTNAME_COMMAND: "route -n | awk '/UG[ \t]/{print $$2}'"```

When using commands, make sure you review the "Variable Substitution" section in [https://docs.docker.com/compose/compose-file/](https://docs.docker.com/compose/compose-file/)

If ```KAFKA_ADVERTISED_HOST_NAME``` is specified, it takes presendence over ```HOSTNAME_COMMAND```

For AWS deployment, you can use the Metadata service to get the container host's IP:
```
HOSTNAME_COMMAND=wget -t3 -T2 -qO-  http://169.254.169.254/latest/meta-data/local-ipv4
```
Reference: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html

##Tutorial

[http://wurstmeister.github.io/kafka-docker/](http://wurstmeister.github.io/kafka-docker/)



