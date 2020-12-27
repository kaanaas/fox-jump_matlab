function controls(figure, event)

   global camera
   global yveln
   global face
   global ispara
   global initialjump
   
   switch event.Key
       case 'leftarrow'
           face = "left";
           if camera(1) > -300
               camera(1) = camera(1) - 15;
           else
               camera(1) = camera(1);
           end
       case 'rightarrow'
           face = "right";
           if camera(1) < 300
               camera(1) = camera(1) + 15;
           else
               camera(1) = camera(1);
           end
           
%admin/debugging controls           
       case 'uparrow'
           camera(2) = camera(2) + 10;
       case 'downarrow'
           camera(2) = camera(2) - 10;

       case 'space'
           if yveln == 1 || yveln == 30
               yveln = 1;
           end
           ispara = false;
           if initialjump == false
               initialjump = true;
           end
           
       case 'x'
           close all;
           return;
   
end