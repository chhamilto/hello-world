import-module grouppolicy  
$arrgpo = New-Object System.Collections.ArrayList

  foreach ($loopGPO in Get-GPO -All)
  {
      if ($loopGPO.User.Enabled)
      {
          $AuthPermissionsExists = Get-GPPermissions -Guid $loopGPO.Id -All | Select-Object -ExpandProperty Trustee | ? {$_.Name -eq "Authenticated Users"}
          If (!$AuthPermissionsExists)
          {
              $arrgpo.Add($loopGPO) | Out-Null
          }
      }
  }

  $finalresult = ""

  if($arrgpo.Count -eq 0)
  {
      Write-Output "All Group Policy Objects grant access to Authenticated Users"
      return
  }
  else
  {
      foreach ($loopGPO in $arrgpo)
      {
          $finalresult += "'$($loopgpo.DisplayName)'`n"
      }
      Write-Output $finalresult
  }
