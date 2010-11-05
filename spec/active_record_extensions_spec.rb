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
end

