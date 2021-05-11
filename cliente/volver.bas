private sub form_unload(cancel as integer)
    if bnoreschange = false then
        dim typdevm as typdevmode
        dim lres as long
    
        lres = enumdisplaysettings(0, 0, typdevm)
        with typdevm
            .dmfields = dm_pelswidth or dm_pelsheight
            .dmpelswidth = oldreswidth
           .dmpelsheight = oldresheight
        end with
        lres = changedisplaysettings(typdevm, cds_test)
    end if
end
end sub