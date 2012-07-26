$: << File.join(File.dirname(__FILE__), '..')

require 'test/unit'
require 'test_helper'
require 'zypper'

puts "Testing Zypper::Patch methods..."

class TestPatch < Test::Unit::TestCase
  include TestHelper

  def setup
    @patch = Zypper::Patch.new
  end

  def teardown
    unstub
  end

  def test_all
    prepare_data('patches-all', 'xml')

    assert_equal(1331, @patch.all.size)
  end

  def test_applicable
    prepare_data('patches-all', 'xml')

    assert_equal(8, @patch.applicable.size)

    assert_equal(1, @patch.applicable(
      :name => 'slessp2-sysvinit'
    ).size)

    assert_equal(0, @patch.applicable(
      :name => 'no-such-patch-exists'
    ).size)
  end

  def test_applicable?
    prepare_data('patches-all', 'xml')

    assert @patch.applicable?
  end

  def test_installed
    prepare_data('patches-all', 'xml')

    assert_equal(187, @patch.installed.size)

    assert_equal(72, @patch.installed(
      :category => Zypper::Patch::Category::SECURITY
    ).size)
  end

  def test_find
    prepare_data('patches-all', 'xml')

    assert_equal(1136, @patch.find(
      :status => Zypper::Patch::Status::NOT_APPLICABLE
    ).size)

    assert_equal(11, @patch.find(
      :status => Zypper::Patch::Status::NOT_APPLICABLE,
      :name => 'sdksp1-libopenssl-devel'
    ).size)

    assert_equal(718, @patch.find(
      :category => Zypper::Patch::Category::RECOMMENDED
    ).size)

    assert_equal(25, @patch.find(
      :category => Zypper::Patch::Category::OPTIONAL
    ).size)

    # FIXME: use parsed :source
    #assert_equal(765, @patch.find(
    #  :repository => 'SLES11-SP1-Updates'
    #).size)

    assert_equal(8, @patch.find(
      #:repository => 'SLES11-SP1-Updates',
      :name => 'slessp1-apache2-mod_php5'
    ).size)

    assert_equal(2, @patch.find(:edition => '3970').size)

    #assert_equal(1, @patch.find(
    #  :repository => 'SLES11-SP1-Updates',
    #  :edition => '3970'
    #).size)
  end
end