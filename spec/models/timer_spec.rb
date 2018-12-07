# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timer, type: :model do
  it { should belong_to(:match).dependent(:destroy) }

  it do
    should define_enum_for(:status).with_values(
      pending: "pending",
      in_progress: "in_progress",
      paused: "paused",
      expired: "expired",
      canceled: "canceled"
    ).backed_by_column_of_type(:enum)
  end

  subject { create(:match, duration: 5.seconds.to_i).timer }

  it "should function as a timer successfully throughout the game" do
    freeze_time
    subject.start
    travel_to 2.seconds.from_now
    subject.pause
    expect(subject.paused_with.round).to eq(3.seconds)
    subject.resume
    travel_to 2.seconds.from_now
    subject.pause
    expect(subject.paused_with.round).to eq(1.second)
    subject.stop
    expect(subject.paused_with).to eq(nil)
    expect(TimerWorker.jobs.size).to eq(2)
  end

  describe "#duration" do
    it "should return the associated match duration" do
      expect(subject.duration).to eq(5)
    end
  end

  describe "#start" do
    it "fires a worker and updates the timer status and jid columns" do
      freeze_time do
        expect { subject.start }.to change { TimerWorker.jobs.size }.by(1)
          .and change { subject.status }.from("pending").to("in_progress")
          .and change { subject.jid }
      end
    end
  end

  describe "#pause" do
    it "updates the timer status, paused_with, and expires_at columns" do
      freeze_time do
        expect { subject.pause }.to change { subject.paused_with }.to(subject.expires_at - Time.now)
          .and change { subject.expires_at }.to(nil)
          .and change { subject.status }.from("pending").to("paused")
      end
    end
  end

  describe "#resume" do
    it "fires a new worker and updates the timer paused_with, expires_at, jid and status columns" do
      freeze_time do
        subject.update(paused_with: 8.0)
        expected = (Time.now + subject.paused_with)

        expect { subject.resume }.to change { subject.expires_at }.to(expected)
          .and change { subject.paused_with }.to(nil)
          .and change { subject.status }.to("in_progress")
          .and change { subject.jid }
      end
    end
  end

  describe "#stop" do
    it "updates the timer timer paused_with, expires_at and status columns" do
      freeze_time do
        expect { subject.stop }.to change { subject.expires_at }.to(Time.now)
          .and change { subject.status }.to("canceled")
        expect(subject.paused_with).to be_nil
        expect(subject.jid).to be_nil
      end
    end
  end

  describe "#truly_expired?" do
    context "when timer is in progress and expired" do
      it "returns true" do
        timer = build_stubbed(:timer, status: "in_progress", expires_at: 5.seconds.ago)

        expect(timer.truly_expired?).to eq(true)
      end
    end

    context "when timer is in progress and not expired" do
      it "returns false" do
        timer = build_stubbed(:timer, status: "in_progress", expires_at: 5.seconds.from_now)

        expect(timer.truly_expired?).to eq(false)
      end
    end

    context "when timer is not in progress and expired" do
      it "returns false" do
        timer = build_stubbed(:timer, status: "paused", expires_at: 5.seconds.ago)

        expect(timer.truly_expired?).to eq(false)
      end
    end

    context "when timer is not in progress and not expired" do
      it "returns false" do
        timer = build_stubbed(:timer, status: "paused", expires_at: 5.seconds.from_now)

        expect(timer.truly_expired?).to eq(false)
      end
    end
  end
end
