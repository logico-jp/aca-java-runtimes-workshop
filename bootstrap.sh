#!/usr/bin/env bash

### #################################################################
### This script is used to bootstrap the environment for the workshop
### #################################################################


echo "### Removes all the generated files from the project"
rm -rf pom.xml \
  quarkus-app \
  micronaut-app

echo "### Creates a Parent POM"
echo -e "<?xml version=\"1.0\"?>
<project xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd\"
         xmlns=\"http://maven.apache.org/POM/4.0.0\"
         xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
  <modelVersion>4.0.0</modelVersion>
  <groupId>io.containerapps.javaruntime.workshop</groupId>
  <artifactId>parent</artifactId>
  <version>1.0.0-SNAPSHOT</version>
  <packaging>pom</packaging>
  <name>Azure Container Apps and Java Runtimes Workshop</name>
  
  <modules>
    <module>micronaut-app</module>
    <module>springboot-app</module>
  </modules>

</project>
" >> pom.xml


echo "### Bootstraps the Micronaut App"
mn create-app io.containerapps.javaruntime.workshop.micronaut.micronaut-app  \
    --build=maven  \
    --lang=java \
    --java-version=17


echo "### Bootstraps the Quarkus App"
mvn io.quarkus:quarkus-maven-plugin:3.0.0.CR1:create \
    -DplatformVersion=3.0.0.CR1 \
    -DprojectGroupId=io.containerapps.javaruntime.workshop \
    -DprojectArtifactId=quarkus-app \
    -DprojectName="Azure Container Apps and Java Runtimes Workshop :: Quarkus" \
    -DjavaVersion=17 \
    -DclassName="io.containerapps.javaruntime.workshop.quarkus.QuarkusResource" \
    -Dpath="/quarkus" \
    -Dextensions="resteasy, resteasy-jsonb, hibernate-orm-panache, jdbc-postgresql"

echo "### Bootstraps the Spring Boot App"
curl https://start.spring.io/starter.tgz  -d bootVersion=3.0.5 -d javaVersion=17 -d dependencies=web,data-jpa,postgresql,testcontainers -d type=maven-project -d packageName=io.containerapps.javaruntime.workshop.springboot -d artifactId=springboot-app -d version=1.0.0-SNAPSHOT -d baseDir=springboot-app -d name=springboot -d groupId=io.containerapps.javaruntime.workshop -d description=Azure%20Container%20Apps%20and%20Java%20Runtimes%20Workshop%20%3A%3A%20Spring%20Boot | tar -xzvf -

echo "### Running all the Tests"
mvn test


echo "### Adding .editorconfig file"
echo -e "# EditorConfig helps developers define and maintain consistent
# coding styles between different editors and IDEs
# editorconfig.org

root = true

[*]

# We recommend you to keep these unchanged
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

# Change these settings to your own preference
indent_style = space
indent_size = 4

[*.{ts, tsx, js, jsx, json, css, scss, yml}]
indent_size = 2

[*.md]
trim_trailing_whitespace = false
max_line_length = 1024
" >> quarkus-app/.editorconfig

cp quarkus-app/.editorconfig micronaut-app/.editorconfig
cp quarkus-app/.editorconfig springboot-app/.editorconfig
