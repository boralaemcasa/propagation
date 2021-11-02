public static SFrac Incrementar(String p, String q, boolean co_prime, int halfMode) {
  SFrac Result = new SFrac();
  String m, rr, x, y;
  int i, reg;

  if (co_prime)
  {
    m = gcd(p, q);
    Result = Divide(p, m);
	x = Result.n;
	rr = Result.d;
    Result = Divide(q, m, y, rr);
	y = Result.n;
	rr = Result.d;
  }
  else
  {
    x = p;
    y = q;
  }

  rr = Soma(Multiplica(x, x), Multiplica(y, y));
  if ((halfMode == halfXnegative) && (SNumCompare(x, "0") > 0))
  {
    x = "0";
    y = sqrt(rr);
  }
  else if ((halfMode == halfYnegative) && (SNumCompare(y, "0") > 0))
  {
    x = Oposto(sqrt(rr));
    y = "0";
  }
  else if ((halfMode == halfXPositive) && (SNumCompare(x, "0") < 0))
  {
    x = "0";
    y = Oposto(sqrt(rr));
  }
  else if ((halfMode == halfYPositive) && (SNumCompare(y, "0") < 0))
  {
    x = sqrt(rr);
    y = "0";
  }

  reg = region(x, y);
  i = -2;

  do {
    if ((SNumCompare(y, "0") > 0) || (y == "0") && (SNumCompare(x, "0") > 0))
    {
      while (SNumCompare(Subtrai(x, "1") , Oposto(sqrt(rr))) > 0)
      {
        x = Subtrai(x, "1");
        y = sqrt(Subtrai(rr, Multiplica(x, x)));

        if (! bloqueio(x, y, co_prime, halfMode))
        {
          Result.n = x;
          Result.d = y;
          return Result;
        }

        if ((region(x, y) != reg) && (! bloqueio(x, y, co_prime, halfMode, false)))
        {
          i++;
          if (i == 1)
            break;
          reg = region(x, y);
        }
      }

      if (i < 1)
      {
        if (co_prime)
        {
          x = Oposto(sqrt(Subtrai(rr, "1")));
          y = "-1";
        }
        else
        {
          x = Oposto(sqrt(rr));
          y = "0";
        }

        if (! bloqueio(x, y, co_prime, halfMode))
        {
          Result.n = x;
          Result.d = y;
          return Result;
        }
        x = trunc(x);
        if (! co_prime)
          x = Subtrai(x, "1"); // y = 0 is welcome. x = x - 1 + 1
      }
    }

    if (i < 1)
      while (SNumCompare(Soma(x, "1") , sqrt(rr)) < 0)
      {
        x = Soma(x, "1");
        y = Oposto(sqrt(Subtrai(rr , Multiplica(x , x))));
        if (! bloqueio(x, y, co_prime, halfMode))
        {
          Result.n = x;
          Result.d = y;
          return Result;
        }

        if ((region(x, y) != reg) && (! bloqueio(x, y, co_prime, halfMode, false)))
        {
          i++;
          if (i == 1)
            break;
          reg = region(x, y);
        }
      }

    rr = Soma(rr, "1");
    if (co_prime)
    {
      x = sqrt(Subtrai(rr, "1"));
      y = "1";
    }
    else
    {
      x = sqrt(rr);
      y = "0";
    }

    if (! bloqueio(x, y, co_prime, halfMode))
    {
      Result.n = x;
      Result.d = y;
      return Result;
    }

    reg = 1; // region(x, y);
    i = -2;

    x = trunc(x);
    if (! co_prime)
      x = Soma(x, "1"); // y = 0 is welcome. x = x + 1 - 1
  } while (true);
  
  return Result;
}

