$(document).ready( function() {
  $('.multiselect_regions').multiselect( {
    includeSelectAllOption: true,
    selectAllValue: "",
    includeSelectAllDivider: true,
    buttonText: function(options, select) {
      return "Restrict to Regions"
    },
    buttonTitle: function(options, select) {
      return "Restrict to Regions"
    }
  })
})
