# terraform-module-openshift


This module provides a complete openshift origin cluster.


It uses the terraform env functionality - to get started, clone this repo, change into the implementation folder and run `terraform env list`.

```
* default
  ggcommontest
  ggdestest
  ggmoneytest
```

You can switch between these environments with
```terraform select <envname>```

Please keep default as empty state, to prevent accidental deletion.
