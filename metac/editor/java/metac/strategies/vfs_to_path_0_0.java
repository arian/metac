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

    String url = asJavaString(surl);
    int length;

    if (url.startsWith("file://")) {

      String pp = "file://";
      length = pp.length();

    } else {

      FileObject c = ((IContext) context.contextObject()).location();
      String pp = c.getName().getURI();
      // +1 for the leading slash
      length = pp.length() + 1;

    }

    url = url.substring(length);

    return factory.makeString(url);
  }

}
