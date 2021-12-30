classdef GlobalClass
   properties
      N
      M
      Lower
      Upper
	  Epoca
   end
   methods
      function pop = Initialization(obj)
          pop = rand(obj.N, obj.M);
      end
      function flagContinue = NotTermination(obj, Population)
          flagContinue = (obj.Epoca < 10);
      end
      function Offspring = Variation(obj, Population, MatingPool)
          Offspring = IEAreal(obj, Population, MatingPool);
      end
      function [a, b, c, d] = ParameterSet(obj, a, b, c, d)
      end
   end
end