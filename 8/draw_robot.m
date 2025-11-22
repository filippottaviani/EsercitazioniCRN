function draw_robot(x, y, th, col)
    % Disegna un semplice triangolo per rappresentare il robot
    R = 0.3; % Dimensione robot
    p1 = [x + R*cos(th); y + R*sin(th)];
    p2 = [x + R*cos(th + 2.5); y + R*sin(th + 2.5)];
    p3 = [x + R*cos(th - 2.5); y + R*sin(th - 2.5)];
    plot([p1(1) p2(1) p3(1) p1(1)], [p1(2) p2(2) p3(2) p1(2)], col, 'LineWidth', 2);
end