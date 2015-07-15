package metac;

import org.strategoxt.imp.runtime.dynamicloading.Descriptor;
import org.strategoxt.imp.runtime.services.MetaFileLanguageValidator;

public class MetacValidator extends MetaFileLanguageValidator {

  @Override
  public Descriptor getDescriptor() {
    return MetacParseController.getDescriptor();
  }

}
