locals {
    
  existing_groups = zipmap(
                            data.azuread_groups.all.display_names
                            , data.azuread_groups.all.object_ids
                          )
  
}