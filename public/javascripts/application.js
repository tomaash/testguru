// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function TestPositiveness(number) {
  reg = /^\d+$/;
  if (!(number = parseInt(number) > 0)) {
    alert('Počet otázek musí být kladný');
    document.getElementById("commit").disabled = true;
  } else
  document.getElementById("commit").disabled = false;
}
