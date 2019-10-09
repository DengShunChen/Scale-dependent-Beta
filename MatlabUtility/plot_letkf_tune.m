 clc;
 clear all;


figure
xtick = 03:2:17 ;
ytick = 1.01:0.02:1.11 ; 

% Imperfect model from prob(x,y) , x : inflation factor ; y : localization length
%prob(1:6,1) = [ 0.2227    0.1874    0.1784    0.1799    0.1889    0.2020 ]';
%prob(1:6,2) = [ 0.2116    0.1762    0.1670    0.1660    0.1708    0.1786 ]';
%prob(1:6,3) = [ 0.2132    0.1797    0.1675    0.1649    0.1687    0.1736 ]';
%prob(1:6,4) = [ 0.2169    0.1797    0.1699    0.1667    0.1693    0.1743 ]';
%prob(1:6,5) = [ 0.2255    0.1876    0.1730    0.1702    0.1726    0.1756 ]';
%prob(1:6,6) = [ 0.2328    0.1925    0.1785    0.1746    0.1743    0.1785 ]';
%prob(1:6,7) = [ 0.2426    0.1987    0.1838    0.1762    0.1787    0.1804 ]';
%prob(1:6,8) = [ 0.2532    0.2055    0.1872    0.1814    0.1816    0.1842 ]'; 

prob(1:6,1) = [ 0.1630    0.1520    0.1583    0.1676    0.1799    0.1964 ]';
prob(1:6,2) = [ 0.1618    0.1479    0.1492    0.1549    0.1633    0.1741 ]';
prob(1:6,3) = [ 0.1638    0.1510    0.1486    0.1536    0.1596    0.1677 ]';
prob(1:6,4) = [ 0.1708    0.1527    0.1506    0.1538    0.1587    0.1674 ]';
prob(1:6,5) = [ 0.1794    0.1574    0.1539    0.1551    0.1595    0.1647 ]';
prob(1:6,6) = [ 0.1845    0.1632    0.1552    0.1571    0.1607    0.1662 ]';
prob(1:6,7) = [ 0.1896    0.1682    0.1575    0.1599    0.1625    0.1681 ]';
prob(1:6,8) = [ 0.1964    0.1709    0.1636    0.1634    0.1652    0.1702 ]'; 

imagesc(xtick,ytick,prob)
%colormap(summer(64))
colormap(hot(64))
	colorbar

set(gca, ...
    'XAxisLocation','bottom', ...
    'XTick',xtick, ...
    'YTick',ytick, ...
    'Ydir','normal')

[rows,cols] = size(prob);

for i = 1:rows
  for j =  1:cols
    text(xtick(j),ytick(i),sprintf('%1.3f',prob(i,j)),...
        'FontSize', 12, ...
      'Color','blue', ...
      'HorizontalAlignment','center',...
      'FontWeight','bold');
  end
end

xlabel('Localization length (grid)')
ylabel('Inflation factor')

print('Imperfect_letkf','-dpng')
print('Imperfect_letkf','-dpdf')
