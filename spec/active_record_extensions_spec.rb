#
# © Copyright 2010 Olexiy Zamkoviy. All Rights Reserved.
#

require 'spec_helper'

describe "active_record_extensions" do
  context "IDENTIFIER_LIST_G_RE" do
    it { "asdf,jkl,zxcv".should match(ActiveRecord::Base.const_get("IDENTIFIER_LIST_G_RE")) }
    it { "asdf,jkl,zxcv,".should_not match(ActiveRecord::Base.const_get("IDENTIFIER_LIST_G_RE")) }
    it { "asdf ,jkl,zxcv".should_not match(ActiveRecord::Base.const_get("IDENTIFIER_LIST_G_RE")) }
    it { "as df,jkl,zxcv".should_not match(ActiveRecord::Base.const_get("IDENTIFIER_LIST_G_RE")) }
  end

  context "URL_RE" do
    it { "http://test.com/".should match(ActiveRecord::Base.const_get('URL_RE')) }
    it { "https://test.com/".should match(ActiveRecord::Base.const_get('URL_RE')) }
    it { "http://subdomain.test.com/".should match(ActiveRecord::Base.const_get('URL_RE')) }
    it { "http://wrong domain.test.com/".should_not match(ActiveRecord::Base.const_get('URL_RE')) }
    it { "http://wrongdomain!.test.com/".should_not match(ActiveRecord::Base.const_get('URL_RE')) }
    it { "http://wrongdomain@.test.com/".should_not match(ActiveRecord::Base.const_get('URL_RE')) }
    it { "http://wrongdomain#.test.com/".should_not match(ActiveRecord::Base.const_get('URL_RE')) }
    it { "http://test/".should_not match(ActiveRecord::Base.const_get('URL_RE')) }
  end
end

