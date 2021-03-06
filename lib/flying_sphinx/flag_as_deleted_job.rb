# A simple job for flagging a specified Sphinx document in a given index as
# 'deleted'.
#
class FlyingSphinx::FlagAsDeletedJob
  attr_accessor :indices, :document_id

  # Initialises the object with an index name and document id. Please note that
  # the document id is Sphinx's unique identifier, and will almost certainly not
  # be the model instance's primary key value.
  #
  # @param [String] index The index name
  # @param [Integer] document_id The document id
  #
  def initialize(indices, document_id)
    @indices, @document_id = indices, document_id
  end

  # Updates the sphinx_deleted attribute for the given document, setting the
  # value to 1 (true). This is not a special attribute in Sphinx, but is used
  # by Thinking Sphinx to ignore deleted values between full re-indexing. It's
  # particularly useful in this situation to avoid old values in the core index
  # and just use the new values in the delta index as a reference point.
  #
  # @return [Boolean] true
  #
  def perform
    ThinkingSphinx::Connection.take do |client|
      indices.each do |index|
        client.update index, ['sphinx_deleted'], {@document_id => [1]}
      end
    end
  rescue Riddle::ConnectionError
    # If it fails here, so be it.
  ensure
    true
  end
end
