    '''''''''''cambiar la resolucion
    
    dim typdevm as typdevmode
    dim lres as long
    
    lres = enumdisplaysettings(0, 0, typdevm)
    
    'uso esta procedure para saber la actual rez
    'porque enumdisplay me devuelve un valor
    'incorrecto (ie. a mi siempre me dio 640x480
    'aun estando en 800x600)
        dim intwidth as integer
        dim intheight as integer

        oldreswidth = screen.width \ screen.twipsperpixelx
       oldresheight = screen.height \ screen.twipsperpixely
    'zzzzzzzzzzzzzzzzzzzzzzzzz

    if oldreswidth <> 800 and oldresheight <> 600 then
        'call changedisplaysettings(typdevm, cds_updateregistry)
        with typdevm
            .dmfields = dm_pelswidth or dm_pelsheight or dm_bitsperpel
            .dmpelswidth = 800
            .dmpelsheight = 600
            .dmbitsperpel = 16
        end with
        lres = changedisplaysettings(typdevm, cds_test)
        'if lres = disp_change_failed then msgbox "yay"
        'if lres = disp_change_successful then call changedisplaysettings(typdevm, cds_updateregistry)
      else
        bnoreschange = true
    end if