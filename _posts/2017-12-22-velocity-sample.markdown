---
layout: "post"
title: "Velocity Sample"
date: "2017-12-22 09:57"
categories:  javs
---

# Velocity sample source

```bash
kubectl create secret docker-registry rediikey --docker-server=<imagerepourl> --docker-username=<username> --docker-password=<password> --docker-email=<email>
```

## Velocity sample - loading template form file
```java
public class Dockerfile
{
    public static void main( String[] args )
    {
    	VelocityEngine ve = new VelocityEngine();

      ve.setProperty(RuntimeConstants.RESOURCE_LOADER, "classpath");
      ve.setProperty("classpath.resource.loader.class", ClasspathResourceLoader.class.getName());
    	ve.init();

    	Template t = ve.getTemplate("Dockerfile"); // classpath on resource

    	Map<String, String> var = new HashMap<String, String>();
    	var.put("baseImage", "<IMAGE_URL>");

    	VelocityContext context = new VelocityContext();
    	context.put("var", var);

    	StringWriter writer = new StringWriter();
    	t.merge( context, writer );

    	System.out.println(writer.toString());
    }
}

```

## Velocity sample - loading template from String

```java
private String velocityTemplating(String sourceTemplate) {

       String result;

       VelocityEngine engine = new VelocityEngine();

       engine.setProperty(RuntimeConstants.RESOURCE_LOADER, "string");
       engine.addProperty("string.resource.loader.class", StringResourceLoader.class.getName());
       engine.addProperty("string.resource.loader.repository.static", "false");

       engine.init();

       StringResourceRepository repo = (StringResourceRepository) engine.getApplicationAttribute(StringResourceLoader.REPOSITORY_NAME_DEFAULT);
       repo.putStringResource("source", sourceTemplate);

       // Set parameters for my template.
       VelocityContext context = new VelocityContext();

       Map<String, String> var = new HashMap<String, String>();

       var.put("baseImage", baseImageUrl);

       context.put("var", var);

       // Get and merge the template with my parameters.
       Template template = engine.getTemplate("source");
       StringWriter writer = new StringWriter();
       template.merge(context, writer);

       result = writer.toString();
       return result;
}
```

## Sample Velocity Template

```Dockerfile
FROM ${var.baseImage} #

# USER root
USER 0

RUN mkdir -p /Anyframe/AttatchedFiles

#if( $var.baseImage == "<IMAGE_URL_A>" )
ENV JAVA_OPTS="$JAVA_OPTS -Djava.security.egd=file:/dev/./urandom"

# App upload
COPY camellia.war /opt/jboss/wildfly/standalone/deployments/camellia.war

#elseif( $var.baseImage == "<IMAGE_URL_B>" || $var.baseImage == "IMAGE_URL_C" )

# App upload
COPY camellia.war /opt/eap/standalone/deployments/camellia.war

RUN chmod -R 777 /opt/eap/standalone/deployments/camellia.war
RUN chown -Rf jboss.root /opt/eap/modules/system/layers/openshift/com
RUN chmod -R 777 /opt/eap/modules/system/layers/openshift/com

USER jboss
# USER 185
#end
```
