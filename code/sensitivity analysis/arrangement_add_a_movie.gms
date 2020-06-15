$Title  final project arrangement_add_a_movie
$Ontext

This problem finds a least cost shipping schedule that meets
requirements at markets and supplies at factories.


Dantzig, G B, Chapter 3.3. In Linear Programming and Extensions.
Princeton University Press, Princeton, New Jersey, 1963.

This formulation is described in detail in:
Rosenthal, R E, Chapter 2: A GAMS Tutorial. In GAMS: A User's Guide.
The Scientific Press, Redwood City, California, 1988.

The line numbers will not match those in the book because of these
comments.

$Offtext


  Sets
       i   moviehall   / Hall1,Hall2,Hall3,Hall4,Hall5,Hall6  /
       j   film          / a, b, c, d, e, f, g /
       k   timeslot         /morning, noon,  afternoon, evening, night, midnight/;

  Parameters

       a(i)  capacity of moviehall i in cases
         /    Hall1     338
              Hall2     338
              Hall3     108
              Hall4     108
              Hall5     48
              Hall6     50 /

       retail(k) ratio of customers who might buy snacks before entering moviehalls at different timeslot k in cases
        /     morning      0.1
              noon         0.3
              afternoon    0.5
              evening      0.7
              night        0.3
              midnight     0.1 /

       cost(i)  cost of mamnagement in each moviehall i in cases
         /    Hall1     410
              Hall2     410
              Hall3     186
              Hall4     186
              Hall5     107
              Hall6     107 / ;

  Table price(k,j)  ticket price of film j at different timeslot k in cases
                   a        b        c        d        e        f         g
      morning      54.00    36.00    59.00    21.00    44.00    15.00     54.00
      noon         64.00    36.00    59.00    21.00    44.00    19.00     64.00
      afternoon    69.00    36.00    59.00    26.00    44.00    19.00     69.00
      evening      69.00    49.00    64.00    26.00    49.00    24.00     69.00
      night        69.00    49.00    64.00    29.00    49.00    26.00     69.00
      midnight     59.00    49.00    64.00    26.00    44.00    24.00     59.00;

  Table number(k,i)  number of films each hall plays
                     Hall1        Hall2      Hall3    Hall4    Hall5  Hall6
        morning         1           1           1       1       1       1
        noon            1           1           1       1       1       1
        afternoon       1           1           1       1       1       1
        evening         1           1           1       1       1       1
        night           1           1           1       1       1       1
        midnight        1           1           1       1       1       1  ;

  Table ratio(k,j)  ratio of seat sold of film j at different timeslot k in cases
                          a          b         c        d         e       f     g
        morning         0.50       0.60      0.67      0.23     0.54    0.12   0.50
        noon            0.60       0.60      0.74      0.30     0.65    0.23   0.60
        afternoon       0.65       0.70      0.78      0.32     0.65    0.34   0.65
        evening         0.70       0.80      0.91      0.43     0.76    0.45   0.70
        night           0.88       0.90      0.95      0.56     0.78    0.56   0.88
        midnight        0.80       0.60      0.88      0.54     0.88    0.45   0.80      ;


  Scalar average_price   billing in dollars per consumption  /25/;
  Scalar average_price_ratio   ratio of margin in dollars per consumption  /0.65/;

  Integer Variables
       x(i,j,k)  arrangement of Hall i at timeslot k whether or not play film j;

  Variables
       z   total profit ;


  Equations
       revenue        define objective function
       provide(i,k)   requirement of number of plays moviehall i can provide at different timeslot k
       demand(j)      requirement of every film played at peak time ;

  revenue ..        z  =e=  sum((i,j,k), a(i)*price(k,j)*ratio(k,j)*x(i,j,k))+sum(k,average_price_ratio*average_price*retail(k)*sum((i,j),ratio(k,j)*a(i)*x(i,j,k)))- sum(i,cost(i)*sum((j,k),x(i,j,k))) ;

  provide(i,k) ..   sum(j, x(i,j,k))  =l=  number(k,i) ;

*demand(j,k) ..      sum(i, x(i,j,k))  =g=  1 ;

  demand(j) ..      sum((i,k), x(i,j,k))  =g=  2 ;


  Model arrangement_add_a_movie /all/ ;

  option mip=cplex;

$onecho > cplex.opt
objrng all
rhsrng all
$offecho
  arrangement_add_a_movie.OptFile=1;

  solve arrangement_add_a_movie maximizing z using mip;

  Display x.l,x.m,z.l;
*file output /output-16x7.txt/;
*put output;
