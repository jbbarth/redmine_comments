require "spec_helper"

describe "Inline images in notes", type: :helper do

  fixtures :users, :roles, :projects, :members, :member_roles, :issues, :issue_statuses,
           :trackers, :enumerations, :enabled_modules, :journals

  let(:issue) { Issue.find(1) }

  def attach_image(container, filename)
    attachment = Attachment.new(container: container, filename: filename, disk_filename: "#{filename}.tmp",
                                filesize: 10, content_type: "image/png", author_id: 1)
    attachment.save(validate: false)
    attachment
  end

  before do
    User.current = User.find(1)
    allow(Setting).to receive(:text_formatting).and_return("common_mark")
  end

  it "renders an image attached to a private note" do
    note = Journal.create!(journalized: issue, user_id: 1, private_notes: true, notes: "![](capture.png)")
    attachment = attach_image(note, "capture.png")

    html = helper.textilizable(note, :notes)

    expect(html).to include(%(src="/attachments/download/#{attachment.id}/capture.png"))
  end

  it "still renders an image attached to the issue" do
    note = Journal.create!(journalized: issue, user_id: 1, notes: "![](issue.png)")
    attachment = attach_image(issue, "issue.png")

    html = helper.textilizable(note, :notes)

    expect(html).to include(%(src="/attachments/download/#{attachment.id}/issue.png"))
  end
end
