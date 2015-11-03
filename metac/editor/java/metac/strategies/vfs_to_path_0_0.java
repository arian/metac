package metac.strategies;

import static org.spoofax.interpreter.core.Tools.asJavaString;

import org.apache.commons.vfs2.FileObject;
import org.metaborg.core.context.IContext;
import org.spoofax.interpreter.terms.IStrategoTerm;
import org.spoofax.interpreter.terms.ITermFactory;
import org.strategoxt.lang.Context;
import org.strategoxt.lang.Strategy;

public class vfs_to_path_0_0 extends Strategy {

  public static vfs_to_path_0_0 instance = new vfs_to_path_0_0();

  public IStrategoTerm invoke(Context context, IStrategoTerm surl) {
    ITermFactory factory = context.getFactory();

    FileObject c = ((IContext) context.contextObject()).location();
    String pp = c.getName().getURI();

    String url = asJavaString(surl);

    // +1 for the leading slash
    return factory.makeString(url.substring(pp.length() + 1));
  }

}
