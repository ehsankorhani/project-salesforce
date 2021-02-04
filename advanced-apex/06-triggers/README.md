# Triggers

## One trigger per Type

We cannot predict the order of execution if there is more than one trigger for a same type.

- Static variables can be used to prevent recursion.
- A collection can hold all data to be updated. Classes can pass this collection until a single *DML Update* handles all of the updates at once.


## Managing the Data Updates

- On before trigger all of the fields are present, and those that are updatable, can be updated.
- On after trigger a DML operation is required and cannot be performed on the new, old, newMap and oldMap. variables, have all their fields set to read-only.



## Best practices

### Before vs. After Triggers


### Missing Triggers
- Delete triggers typically do not fire on cascade deletes.
  - create a before-delete trigger on the parent object and perform operation on the child objects (be sure to design this carefully – there may be a large number of child objects).
- Reparenting of objects during a merge or conversion may not fire update or delete triggers.
