# CSSO
CSSO is a great tool for optimizing CSS. It's public API is very simple, sometimes to a fault, where it becomes difficult to track down errors. Although we're considering building in some extra error tracking in the future, for now just be careful.

## Additional Options

### No Restructure
 - key: `no_restructure`
 - type: `Boolean`
 - default: `false`

If set to true it disables structure minimization. Structure minimization is a feature that merges together blocks that have the same selector.
