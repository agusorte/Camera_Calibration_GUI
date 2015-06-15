function plot_scan(scan,scan_seg,handles,show_real)


hold on;
axes(handles.axes_3Dpoints)
if(show_real)
    plot3(scan(:,1),scan(:,2),scan(:,3),'b.','MarkerSize',0.5);
    plot3(scan_seg(:,1),scan_seg(:,2),scan_seg(:,3),'r.','MarkerSize',0.5);
else
    plot3(scan_seg(:,1),scan_seg(:,2),scan_seg(:,3),'b.','MarkerSize',0.5);
end;
hold on;
Xax=max(scan(:,1));
Yax=max(scan(:,2));
Zax=max(scan(:,3));
plot3([0 Xax],[0 0],[0 0],'r-','linewidth',2),text(Xax,0,0,'X');
plot3([0 0],[0 Yax],[0 0],'g-','linewidth',2),text(0,Yax,0,'Y');
plot3([0 0],[0 0],[0 Zax],'b-','linewidth',2),text(0,0,Zax,'Z');