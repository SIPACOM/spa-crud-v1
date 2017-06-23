# spa-crud-v1
Crud Generator From JPA Modeler

### CRUD Option


```java
 crud.include //entity name
 crud.exclude //entity name
 crud.addXSLT //include XSLT Template for code generation
 crud.template //template or group files
 crud.packageBase //set package base
 crud.addJPAModel //set JPA Model *.jpa (xml file)
```

### XSLT Template
```xml
part.xsl <!-- Generate HTML for table/form/filter -->
view.xsl <!-- Generate HTML for process -->
ctrl.xsl <!-- Generate NG-CTRL for process -->
rest.xsl <!-- Generate JAX-RS for process -->
serv.xsl <!-- Generate BEAN-SPEC for process -->
impl.xsl <!-- Generate BEAN-IMPL for process -->
```
### Dependence
ANGULARJS / JQUERY / BOOTSTRAP
