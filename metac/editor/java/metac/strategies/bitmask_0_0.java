package metac.strategies;

import static org.spoofax.interpreter.core.Tools.asJavaInt;

import org.spoofax.interpreter.terms.IStrategoTerm;
import org.spoofax.interpreter.terms.ITermFactory;
import org.strategoxt.lang.Context;
import org.strategoxt.lang.Strategy;

public class bitmask_0_0 extends Strategy {

  public static bitmask_0_0 instance = new bitmask_0_0();

  @Override
  public IStrategoTerm invoke(Context context, IStrategoTerm n_) {
    ITermFactory factory = context.getFactory();

    int n = asJavaInt(n_);
    double p = Math.pow(2, n);
    String f = String.format("0x%X", ((long) p) - 1);

    return factory.makeString(f);
  }

}
