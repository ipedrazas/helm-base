# Helm

This guide provides a few guidelines on using helm (the tool) and charts best practices.


## A bit of History

Helm is a package manager for Kubernetes. Helm uses and defines a few concepts that are important to understand:

* Templates: it's a set of yaml files that define kubernetes resources and allow injecting values into certain parts of the file.
* Values: set of predefined template values that can be injected, pre-defined or overwritten.
* Chart: it's the name that we give to a set of templates plus a set of default values associated with the templates.
* Release: a `release` is the most important part of a helm chart. Not the templates, not the chart, the release. A release is the request to apply a set of changes in a number of objects or resources defined in the Kubernetes API. This is the merge of the templates with a set of values (either coming from a file or overwritten using flags).

Let's look at what do we do when we issue a `helm install` or a `helm upgrade` command.

Kubernetes is a REST API, as such, we can create, update, delete and list objects. To create an object we have to issue a POST request sending a json document describing the object (or objects in the case of sending a list[]) we want to create.

Because writing `JSON` is not the best experience, the `YAML` format was adopted. How do we create an object in kubernetes?

```
kubectl apply -f my-object.yaml
```

This command transforms the `YAML` file into a `JSON` document and issues a POST request to the API Server. It's important to remember because when doing Helm we will suffer from different linting problems, and knowing the different steps help to debug our misconfigured `YAML` document.

Because each resource or object is defined as a `YAML` file, we ended up with too many `YAML` files and `Helm` was the solution the community found to handle a set of kubernetes objects: we created a tool that allowed to separate the `values` from the `templates`. 

Remember that a `YAML` file is just the **serialisation** (declaration of state) of a **Kubernetes object**.

Because an application is usually formed by more than one resource (Pod) we needed a way of bundling objects under a logical entity: this is what a Helm Chart is, a set of resources that once created, define an application. 

Charts have 4 parts:

* metadata
* templates
* values
* helper scripts

But this is only half of the story, this only defines the potential creation of one or more kubernetes resource description. It's when we send these objects to the API Server, we we issue that `POST` command that things get really interesting, because if a chart is a logical entity that bundles templates, metadata, helper functions and values, a `release` is the request issued to the API Server. That `POST` request is what we call `release`, and contains a set of json objects that describe a set of kubernetes resources.

To put it in a more OOP way: templates are the `Interface`, the different values are the default `Constructors` and the releases are the `instances` of our Kubernetes objects in the cluster.


## Helm Commands

Helm provides a long list of commands but there are a few that are particularly useful for an application developer.

### Upgrade

The `upgrade` command is an `upsert`, if the release is not in cluster, it will install it, otherwise it will update it.

```
-> %  helm upgrade -i x01 ./kstatus --set ingress.host=home.test,cluster=Local-mytest --namespace status --debug
```

The sintax is self explanatory:

```
-> %  helm upgrade -i [RELEASE] [CHART] [VALUES] [FLAGS]
```

It's important to notice that when the values file is not specified helm uses the `values.yaml` of the Chart. This means that in reality the command is as follows:

```
-> %  helm upgrade -i x01 ./kstatus -f values.yaml --set ingress.host=home.test,cluster=Local-mytest --namespace status --debug
```

The `--debug` flag displays the templates with the merged values, the `--dry-run` command will not create the resources in the cluster. Combining both flags is a very good way to debug `YAML` templates with wrong values.

When creating releases sometimes we want to have better control of what is happening. Helm provides a few flags to control how the pods a

**--wait:** if set, helm will wait until all Pods, PVCs, Services, and minimum number of Pods of a Deployment are in a **ready** state before marking the release as successful. It will wait for as long as `--timeout`

**--reuse-values:** helm will reuse the last release's values and merge in any overrides from the command line via --set and -f. If `'--reset-values'` is specified, this is ignored.
      
**--recreate-pods:** performs pods restart for the resource if applicable.
      

### Template

There are occasions where we want to generate the `YAML` files to issue a `kubectl apply`, we can use `helm template` for that. For exmaple, the following command will render the `deployment` template using the `values.yaml` file located in the root of the Chart and it will overwrite the `configmap.enabled` key:

```
-> %  helm template ./myapp --name=a01 -x templates/deployment.yaml --set configmap.enabled=true
```

Note that the sintax is slightly different:

```
-> %  helm template [CHART] [RELEASE] [VALUES] 
```

The `-x` flag defines the output directory.
