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
    context "valid cases" do
      it { "http://test.com/".should match(ActiveRecord::Base.const_get('URL_RE')) }
      it { "https://test.com/".should match(ActiveRecord::Base.const_get('URL_RE')) }
      it { "http://subdomain.test.com/".should match(ActiveRecord::Base.const_get('URL_RE')) }
      it { "http://test.com/@!@#!@!@$".should match(ActiveRecord::Base.const_get('URL_RE')) }
    end

    context "invalid cases" do
      it { "http://wrong domain.test.com/".should_not match(ActiveRecord::Base.const_get('URL_RE')) }
      it { "http://wrongdomain!.test.com/".should_not match(ActiveRecord::Base.const_get('URL_RE')) }
      it { "http://wrongdomain@.test.com/".should_not match(ActiveRecord::Base.const_get('URL_RE')) }
      it { "http://wrongdomain#.test.com/".should_not match(ActiveRecord::Base.const_get('URL_RE')) }
      it { "http://test/".should_not match(ActiveRecord::Base.const_get('URL_RE')) }

      it "ends with newline" do
        "http://test.com/\n".should_not match(ActiveRecord::Base.const_get('URL_RE'))
      end

      it "ends with caret return" do
        "http://test.com/\r".should_not match(ActiveRecord::Base.const_get('URL_RE'))
      end

      it "begins with newline" do
        "\nhttp://test.com/".should_not match(ActiveRecord::Base.const_get('URL_RE'))
      end

      it "begins with caret return" do
        "\rhttp://test.com/".should_not match(ActiveRecord::Base.const_get('URL_RE'))
      end

      it "contains newline" do
        "http://tes\nt.com/".should_not match(ActiveRecord::Base.const_get('URL_RE'))
      end

      it "contains caret return" do
        "http://tes\rt.com/".should_not match(ActiveRecord::Base.const_get('URL_RE'))
      end
    end
  end

  context "ALNUM_RE" do
    context "valid cases" do
      it { "Alnum".should match(ActiveRecord::Base.const_get('ALNUM_RE')) }
      it { "Alnum123".should match(ActiveRecord::Base.const_get('ALNUM_RE')) }
      it { "Alnum123 ".should match(ActiveRecord::Base.const_get('ALNUM_RE')) }
      it { "123Alnum".should match(ActiveRecord::Base.const_get('ALNUM_RE')) }
    end

    context "invalid cases" do
      it "begins with space" do
        " Alnum123".should_not match(ActiveRecord::Base.const_get('ALNUM_RE')) 
      end

      it { "Alnum#".should_not match(ActiveRecord::Base.const_get('ALNUM_RE')) }
      it { "Alnum$".should_not match(ActiveRecord::Base.const_get('ALNUM_RE')) }

      it "ends with newline" do
        "Alnum\n".should_not match(ActiveRecord::Base.const_get('ALNUM_RE'))
      end

      it "ends with caret return" do
        "Alnum\r".should_not match(ActiveRecord::Base.const_get('ALNUM_RE')) 
      end

      it "contains newline" do
        "Alnum\nxx".should_not match(ActiveRecord::Base.const_get('ALNUM_RE')) 
      end

      it "contains caret return" do
        "Alnum\ryy".should_not match(ActiveRecord::Base.const_get('ALNUM_RE')) 
      end
    end
  end

  context "IDENTIFIER_RE" do
    context "valid cases" do
      it { "Identifer".should match(ActiveRecord::Base.const_get('IDENTIFIER_RE')) }
      it { "Identifier123".should match(ActiveRecord::Base.const_get('IDENTIFIER_RE')) }
    end

    context "invalid cases" do
      it "begins with space" do 
        " Identifier123".should_not match(ActiveRecord::Base.const_get('IDENTIFIER_RE')) 
      end

      it "ends with space" do
        "Identifier123 ".should_not match(ActiveRecord::Base.const_get('IDENTIFIER_RE')) 
      end

      it "ends with newline" do
        "Identifier123\n".should_not match(ActiveRecord::Base.const_get('IDENTIFIER_RE')) 
      end

      it "ends with caret return" do 
        "Identifier123\r".should_not match(ActiveRecord::Base.const_get('IDENTIFIER_RE')) 
      end

      it "contains newline" do 
        "Identifier123\nxx".should_not match(ActiveRecord::Base.const_get('IDENTIFIER_RE')) 
      end

      it "contains caret return" do 
        "Identifier123\ryy".should_not match(ActiveRecord::Base.const_get('IDENTIFIER_RE')) 
      end

      it "begins with number" do 
        "123Identifier".should_not match(ActiveRecord::Base.const_get('IDENTIFIER_RE')) 
      end
    end
  end

  context "IDENTIFIER_LIST_RE" do
    context "valid cases" do
      it { ("a" * 100).should match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE')) }
      it { (("a" * 100) + ',' + ("b" * 100)).should match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE')) }
      it { (["a" * 100] * 10).join(',').should match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE')) }
    end

    context "invalid cases" do
      it { ("a" * 101).should_not match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE')) }

      context "single item" do
        it "ends with newline" do
          ("a" * 99 + "\n").should_not match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE'))
        end

        it "ends with caret return" do
          ("a" * 99 + "\r").should_not match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE'))
        end

        it "contains newline" do
          ("a" * 50 + "\n" + "b" * 49).should_not match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE'))
        end

        it "contains newline" do
          ("a" * 50 + "\n" + "b" * 49).should_not match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE'))
        end
      end

      context "multiple items" do
        it "last element contains newline" do
          (("a" * 100) + ',' + ("b" * 99) + "\n").should_not match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE'))
        end

        it "last element contains caret return" do
          (("a" * 100) + ',' + ("b" * 99) + "\r").should_not match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE'))
        end

        it "first element contains newline" do
          (("a" * 99) + "\n" + ',' + ("b" * 100)).should_not match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE'))
        end

        it "first element contains caret return" do
          (("a" * 99) + "\r" + ',' + ("b" * 100)).should_not match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE'))
        end

        it "newline after all elements" do
          ((["a" * 100] * 10).join(',') + "\n").should_not match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE'))
        end

        it { (("a" * 100) + ',' + ("b" * 101)).should_not match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE')) }
        it { (["a" * 100] * 11).join(',').should_not match(ActiveRecord::Base.const_get('IDENTIFIER_LIST_RE')) }

      end
    end
  end
end

