package metac.strategies;

import static org.spoofax.interpreter.core.Tools.asJavaString;

import java.nio.file.Path;
import java.nio.file.Paths;

import org.spoofax.interpreter.terms.IStrategoTerm;
import org.spoofax.interpreter.terms.ITermFactory;
import org.strategoxt.lang.Context;
import org.strategoxt.lang.Strategy;

public class path_join_0_1 extends Strategy {

  public static path_join_0_1 instance = new path_join_0_1();

  @Override
  public IStrategoTerm invoke(Context context, IStrategoTerm path, IStrategoTerm base) {
    ITermFactory factory = context.getFactory();

    Path p1 = Paths.get(asJavaString(base));
    Path resolved = p1.resolve(asJavaString(path)).normalize();

    return factory.makeString(resolved.toString());
  }

}
